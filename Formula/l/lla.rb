class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "cfbb50f6e72d34485491743da1277b7095e0781efcb0bf4a3cf0b3665818fd5e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3105bf0ef4150916266c249b5e6a74fcddf35deef67cb936b0098be04685849b"
    sha256 cellar: :any, arm64_tahoe:       "f621c2e5b66b2bdb62c9e024db9d7d88ca1c9779ae9977133041f1a740f53f08"
    sha256 cellar: :any, arm64_sequoia:     "25d2c207c8c03576d8181af8b53319d32a2ab91322b0a9f88131c1a3028dbb13"
    sha256 cellar: :any, arm64_linux:       "82db4db662b701b537309311aba9743daf3f19c2a0b53a6e818e59271dd1e129"
    sha256 cellar: :any, x86_64_linux:      "ce1ea0005e97bd75d0679b16ffa1ff1da5c0130cac4cdfe19b7c0afa204e962a"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    generate_completions_from_executable(bin/"lla", "completion")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
