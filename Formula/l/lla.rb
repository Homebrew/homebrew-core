class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8cad0003c54e4f44e62bdabbc5c4a09e5d5d20d241871cf7d54102e9ac29ada8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c1e89691e41a64c405e2286cfb4ca993fd7f2f9e58896bc5fa57860b2ed4918"
    sha256 cellar: :any, arm64_tahoe:       "6c2eb09aa525bd2db488eca52cd3cb58ec1bea9e211baa6291e5ed86e55f299b"
    sha256 cellar: :any, arm64_sequoia:     "eafc99d1ab7104aff9893c345328e52452404edb62650fde3821c82cc2e0980b"
    sha256 cellar: :any, arm64_linux:       "46fa4dd035a3fa8a2da30f29eb7d3b789e30c8c1ff539dcdbe030adbf56ecc66"
    sha256 cellar: :any, x86_64_linux:      "deab6cf8e6b9f4d5f577a498187cba13ab7692e18755e419a37a5d8080c35e86"
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
