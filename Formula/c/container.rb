class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/apple/container/archive/refs/tags/1.0.0.tar.gz"
  sha256 "9f5379d400d23b6f296b7bae8f71f982dfdc1d52bf072ac81318472a734d21f7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/container.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "371fc0f685b7ca0499117a9a0b9d28498bc3bd178918f7bd79c233a7fb0674e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf19c9addbff90135818cadbd3bcc6fcbb76a22a886706888538e6f57ca3f5d"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    system "swift", "build", "--disable-sandbox", "--configuration", "release"

    release_dir = buildpath/".build/release"

    bin.install release_dir/"container"
    bin.install release_dir/"container-apiserver"
    libexec.install "scripts/ensure-container-stopped.sh"

    # Container requires binaries and plugins to be signed with specific entitlements
    codesign "--identifier=com.apple.container.cli", bin/"container"
    codesign "--identifier=com.apple.container.apiserver", bin/"container-apiserver"

    plugins = {
      "container-core-images"   => { source: "CoreImages",       entitlements: false },
      "container-network-vmnet" => { source: "NetworkVMNet",     entitlements: true  },
      "container-runtime-linux" => { source: "RuntimeLinux",     entitlements: true  },
      "machine-apiserver"       => { source: "MachineAPIServer", entitlements: false,
                                     resources: ["init", "create-user.sh"] },
    }
    plugins.each do |bin_name, opts|
      plugin_dir = libexec/"container-plugins/#{bin_name}"
      (plugin_dir/"bin").install release_dir/bin_name
      plugin_dir.install "Sources/Plugins/#{opts[:source]}/config.toml"
      opts[:resources]&.each do |resource|
        (plugin_dir/"resources").install "Sources/Plugins/#{opts[:source]}/Resources/#{resource}"
      end

      entitlement_args = []
      entitlement_args << "--entitlements=signing/#{bin_name}.entitlements" if opts[:entitlements]

      codesign "--prefix=com.apple.container.", *entitlement_args,
               plugin_dir/"bin/#{bin_name}"
    end

    generate_completions_from_executable bin/"container", "--generate-completion-script"

    # Relocate the binaries under libexec and replace them in bin with shim
    # wrappers. The CLI resolves its install root as the lexical grandparent
    # of the running executable (see Sources/ContainerPlugin/InstallRoot.swift),
    # so the binaries must live one directory below the keg root for the
    # bundled plugins under libexec/container-plugins/ to be discovered.
    # CONTAINER_INSTALL_ROOT is also exported by the wrappers for the code
    # paths that honour the environment variable.
    bin.env_script_all_files libexec, CONTAINER_INSTALL_ROOT: opt_prefix
  end

  def codesign(*args)
    system "/usr/bin/codesign", "-f", "-s", "-", *args
  end

  # container APIs aren't guaranteed to be backward compatible,
  # so we stop the system service to ensure no components are out of sync.
  # Ref: https://github.com/apple/container/issues/551#issuecomment-3246928923
  def post_install
    system libexec/"ensure-container-stopped.sh", "-a"
  end

  service do
    run [opt_bin/"container", "system", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/container.log"
    error_log_path var/"log/container.log"
  end

  test do
    # Cannot fully test, as it needs to write outside testpath
    assert_match version.to_s, shell_output("#{bin}/container --version")

    assert_match(/Error: (?:interrupted: ")?internalError: "failed to list containers"/,
                 shell_output("#{bin}/container list 2>&1", 1))
  end
end
