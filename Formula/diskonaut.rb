class Diskonaut < Formula
  desc "Terminal visual disk space navigator"
  homepage "https://github.com/imsnif/diskonaut"
  url "https://github.com/imsnif/diskonaut/archive/0.10.0.tar.gz"
  sha256 "dd33580ffdfb145a9e199350a50d5bc752f2e4161ab32c824b2a9c25005f0e62"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1274eb6a11cf81c7f4c0c51ed89e3c04f284db8c253122b34e9787967f199320" => :catalina
    sha256 "f71266b35c309b22923eae70bd3e0d575da35a70dae1ba598ca3f13e3962ce01" => :mojave
    sha256 "07872d42646d2e7ac73958d5c8b2da3aeaf9f87553436728ae73a0bf2fb7fbc6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/diskonaut", 2
    assert_match output, "Error:\ Failed\ to\ get\ stdout:\ are\ you\ trying\ to\ pipe\ 'diskonaut'\?\n"
  end
end
