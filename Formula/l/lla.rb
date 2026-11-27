class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "866e8d177b4c6e15dc988c49f6b074ce9b4c68fb75e5d3a56486c12626363b1a"
  license "MIT"

  bottle do
    manifest_sha256 "35311523788458323240a03c47d209338cf0954415b215c5e774221856641178"
    sha256 cellar: :any, arm64_golden_gate: "69c5385ffa755e553e721669f709dff5b896a3506ea2516c1661ddd8783ee0b3"
    sha256 cellar: :any, arm64_tahoe:       "3c2d360707a02f8dae46830a55e640798c0d3fa03df50e6300cb2a47a394ab23"
    sha256 cellar: :any, arm64_sequoia:     "1c7b12332f8b801d062fafe4b37340a72fdb2dd67040a08bd243f918d894e0af"
    sha256 cellar: :any, arm64_linux:       "651bfae1c5fc925f0fb068d48e86fc765918cd88528a8caea2ff97c8aa582218"
    sha256 cellar: :any, x86_64_linux:      "7d8a171d7b21bdff4cbb67814960ec344a5de281e227755d2b7b285250904df0"
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
