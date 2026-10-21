class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "cfbb50f6e72d34485491743da1277b7095e0781efcb0bf4a3cf0b3665818fd5e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "04ada9494ca692d23e6b3a71f04ca79fa5182e501e903ad2e2f558fc8e6fcbd7"
    sha256 cellar: :any, arm64_tahoe:       "921b5c0b7f7980153d4c809ff4145483f4a2a41cedb6b3ebf3cf4ef643dd8eb9"
    sha256 cellar: :any, arm64_sequoia:     "413fca6886be03317e5f84731554c9c4d38183e403ade79795a35b36bfd7b01a"
    sha256 cellar: :any, arm64_linux:       "95378baa3bcd9becf0a87fcc953d3e2a81eeef0dc8172aa0c52db77117d533de"
    sha256 cellar: :any, x86_64_linux:      "1b86f4774b945765814647bbdddd5258049ed885667d4523f4e200028b923fee"
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
