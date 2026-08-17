class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c5c198019628688c27398e2a5571362260a629785bce3cc7d6b8aa4141157a2d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2bcdda84a861df270bac949484e5fa7d29eed18be4cd6edba075cd7d97e1bbd6"
    sha256 cellar: :any, arm64_sequoia: "42e490a60992d9600119629f29fcd3ec43b54455022ec37f2aae90a58ffc5dd5"
    sha256 cellar: :any, arm64_sonoma:  "85621995be8f79320dd929b7409793ecec1aa19f5db3f019bf1336c45e051480"
    sha256 cellar: :any, sonoma:        "fce7bfd88219b591f02757c3eae264dce7c882c395c05473691e3c4ba35dfb6b"
    sha256 cellar: :any, arm64_linux:   "38dd5468507c3720bce80ed1a2365416003740c7da6b5c24c33112dd1cc36d4a"
    sha256 cellar: :any, x86_64_linux:  "45d1d978f31552038642bacf8ac2d8cffb4ba6f58e65bb25155f64aa96254a05"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

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
