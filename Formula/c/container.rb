class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/apple/container/archive/refs/tags/0.9.0.tar.gz"
  sha256 "2199d9f7241d7363a7cd3687e4fc3dd571c0b6a52c971266b9f2fe24fdb66eda"
  license "Apache-2.0"
  head "https://github.com/apple/container.git", branch: "main"

  bottle do
    sha256 arm64_tahoe: "4206649cd81aac28ad7118eaf9a8a446cac05cd91a45ddd21ff57382ffaf1823"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on :macos

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    # Replace variable install root path with Homebrew prefix
    inreplace [
      "./Sources/ContainerCommands/Application.swift",
      "./Sources/ContainerCommands/DefaultCommand.swift",
      "./Sources/ContainerPlugin/InstallRoot.swift",
    ] do |s|
      s.gsub!("CommandLine.executablePathUrl",
      "URL(fileURLWithPath: \"#{prefix}\")")
      s.gsub!(/\n\s*\.deletingLastPathComponent\(\)/, "")
      s.gsub!(/\n\s*\.appendingPathComponent\(".."\)/, "")
    end

    system "swift", "build", "--disable-sandbox", "--configuration", "release"

    release_dir = buildpath/".build/release"

    bin.install release_dir/"container"
    bin.install release_dir/"container-apiserver"
    libexec.install "scripts/ensure-container-stopped.sh"

    # Container requires binaries and plugins to be signed with specific entitlements
    codesign "--identifier=com.apple.container.cli", bin/"container"
    codesign "--identifier=com.apple.container.apiserver", bin/"container-apiserver"

    [
      "container-core-images",
      "container-network-vmnet",
      "container-runtime-linux",
    ].each do |plugin|
      (libexec/"container-plugins/#{plugin}/bin").install release_dir/plugin
      (libexec/"container-plugins/#{plugin}").install "config/#{plugin}-config.json" => "config.json"

      entitlement_args = []
      entitlement_args << "--entitlements=signing/#{plugin}.entitlements" if plugin != "container-core-images"

      codesign "--prefix=com.apple.container.", *entitlement_args, libexec/"container-plugins/#{plugin}/bin/#{plugin}"
    end

    generate_completions_from_executable bin/"container", "--generate-completion-script"
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

    output = "Error: interrupted: \"internalError: \"failed to list containers\""
    assert_match output, shell_output("#{bin}/container list 2>&1", 1)
  end
end
