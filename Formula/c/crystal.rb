class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"
  compatibility_version 1

  stable do
    url "https://github.com/crystal-lang/crystal/archive/refs/tags/1.21.0.tar.gz"
    sha256 "5e2d69f565553aa7287e76570d4540a231bfdf1a37f3be179f497ef1df8a0d9a"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/refs/tags/v0.20.0.tar.gz"
      sha256 "8655b87761016409e4411056e350b24e7fe79eae3f227b3354b181a03f14d5da"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "076a2a7aecfc85840e0214a5f3c416f9a88a653aeedd9273045355edae12aa46"
    sha256 cellar: :any, arm64_sequoia: "be23ac3707e6d1ad9ae6d23ae832da7e6b6d47c342337388b9f377261a4fbe5e"
    sha256 cellar: :any, arm64_sonoma:  "7b184d99ca93af6bea62794fecb2e3c594165a0fc570bc5325c0a520c08ab081"
    sha256 cellar: :any, sonoma:        "af9a307681ae730db62a12e1b1da698d9dc510f2a049f99e956f1dfa43bc9774"
    sha256 cellar: :any, arm64_linux:   "fcbb131f3010547b1379eededc042fac32bd1f688002ed36c4400251bd1afe2e"
    sha256 cellar: :any, x86_64_linux:  "89db1c797518979862370fdee66e2f7ad49583cbf179c5eb2f79c2f94dd22400"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git", branch: "master"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git", branch: "master"
    end
  end

  depends_on "asciidoctor" => :build
  depends_on "bdw-gc"
  depends_on "gmp" => :no_linkage # std uses it but it's not linked
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@3" # std uses it but it's not linked
  depends_on "pcre2"
  depends_on "pkgconf" # @[Link] will use pkg-config if available

  uses_from_macos "libffi" # for the interpreter

  on_intel do
    depends_on "libffi"
  end

  # It used to be the case that every new crystal release was built from a
  # previous release, except patches. Crystal is updating its policy to
  # allow 4 minor releases of compatibility unless otherwise specified.
  # Therefore, the boot version should have the MINOR component be
  # between the current minor - 4 and current minor - 1.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    boot_version = Version.new("1.18.2-1")
    version boot_version

    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-darwin-universal.tar.gz"
      # version boot_version
      sha256 "f61620ac389d640d4d429d114c725d6d53df27f0a3e54af25beb398a5815d6db"
    end

    on_linux do
      on_arm do
        url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-aarch64.tar.gz"
        # version boot_version
        sha256 "4bc44af4d9eedff2980b62d57bd0cbc111dd68f5b5b5df22751056aca59948c6"
      end
      on_intel do
        url "https://github.com/crystal-lang/crystal/releases/download/#{boot_version.major_minor_patch}/crystal-#{boot_version}-linux-x86_64.tar.gz"
        # version boot_version
        sha256 "de73134563db840791bc85bacd4e7f1360dc9c04af6e32a9b104300c561716b6"
      end
    end
  end

  # Check version in `shard.lock` in shards repo.
  resource "molinillo" do
    url "https://github.com/crystal-lang/crystal-molinillo/archive/refs/tags/v0.2.0.tar.gz"
    sha256 "e231cf2411a6a11a1538983c7fb52b19e650acc3338bd3cdf6fdb13d6463861a"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    non_keg_only_runtime_deps = deps.filter_map { |dep| dep.to_formula unless dep.build? }
                                    .reject(&:keg_only?)

    resource("boot").stage "boot"
    ENV.append_path "PATH", "boot/bin"
    ENV["LLVM_CONFIG"] = llvm.opt_bin/"llvm-config"
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]
    if OS.mac? && (sdk_path = MacOS.sdk_path)
      ENV.append_path "CRYSTAL_LIBRARY_PATH", sdk_path/"usr/lib"
    end
    non_keg_only_runtime_deps.each do |dep|
      # Our just built `crystal` won't link with some dependents (e.g. `bdw-gc`, `libevent`)
      # unless they're explicitly added to `CRYSTAL_LIBRARY_PATH`. The keg-only dependencies
      # are already in `HOMEBREW_LIBRARY_PATHS`, so there is no need to add them.
      ENV.prepend_path "CRYSTAL_LIBRARY_PATH", dep.opt_lib
    end

    crystal_install_dir = OS.linux? ? libexec : bin
    stdlib_install_dir = pkgshare

    # Avoid embedding HOMEBREW_PREFIX references in `crystal` binary.
    config_library_path = "\\$$ORIGIN/#{HOMEBREW_PREFIX.relative_path_from(crystal_install_dir)}/lib"
    config_path = "\\$$ORIGIN/#{stdlib_install_dir.relative_path_from(crystal_install_dir)}/src"

    release_flags = ["release=true", "FLAGS=--no-debug"]
    crystal_build_opts = release_flags + [
      "CRYSTAL_CONFIG_LIBRARY_PATH=#{config_library_path}",
      "CRYSTAL_CONFIG_PATH=#{config_path}",
      "interpreter=true",
    ]
    crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts
    system "make", "man/crystal.1"

    # Build shards (with recently built crystal)
    resource("shards").stage do
      require "yaml"

      shard_lock = YAML.load_file("shard.lock")
      required_molinillo_version = shard_lock.dig("shards", "molinillo", "version")
      available_molinillo_version = resource("molinillo").version.to_s
      odie "`molinillo` resource is outdated!" if required_molinillo_version != available_molinillo_version

      resource("molinillo").stage "lib/molinillo"

      shards_build_opts = release_flags + [
        "CRYSTAL=#{buildpath}/bin/crystal",
        "SHARDS=false",
      ]
      shards_build_opts << "SHARDS_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?
      system "make", "bin/shards", *shards_build_opts

      # Install shards
      bin.install "bin/shards"
      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    # Install crystal
    crystal_install_dir.install ".build/crystal"
    stdlib_install_dir.install "src"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
    fish_completion.install "etc/completion.fish" => "crystal.fish"

    man1.install "man/crystal.1"

    return unless OS.linux?

    # Wrapper script so that Crystal can find libraries in HOMEBREW_PREFIX
    (bin/"crystal").write_env_script(
      crystal_install_dir/"crystal",
      LD_RUN_PATH: "${LD_RUN_PATH:+${LD_RUN_PATH}:}#{HOMEBREW_PREFIX}/lib",
    )
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
