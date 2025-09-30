class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.4.tar.gz"
  sha256 "535d0b8ef739c4d76a0630ef708d4151c3fb36e73b329f61a81088d22493e7a4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "819244c0a073bac96a7bed5c77e62db4a3fc57144f7d15a01b3c03eeb071731c"
    sha256 cellar: :any,                 arm64_sequoia: "b8e3262661f8853d5a3c2e5a612df1cdb251777baf381ef1da94b79dfa5f38f3"
    sha256 cellar: :any,                 arm64_sonoma:  "b9c0fbcceed69c2ac67ea71a567c0494448b0dbe3a442465c97a0243f16fdc20"
    sha256 cellar: :any,                 arm64_ventura: "2ec8533b051604f4e0f9c116a7e78f6a6f0aec239c511ac5f4f548ce2066352b"
    sha256 cellar: :any,                 sonoma:        "fbdb3997ce23c7484ea50436202fb52d87f201425ee81853d866d558f118572b"
    sha256 cellar: :any,                 ventura:       "6718e6d52e176702caa57cc1a9035433e8279f594835c316d548fb73cf3fd0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f47baefe4e3e67e2493b8bf710a0710ff47cbd101e16bb5f9cbe0e273a7eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7df541facd5da6e412d0251416fa4c3f468480d07b824bb890fddd32eea28a"
  end

  depends_on "rust" => :build
  depends_on "little-cms2"

  def install
    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/jxl-oxide-cli")
  end

  test do
    resource "sunset-logo-jxl" do
      url "https://github.com/libjxl/conformance/blob/5399ecf01e50ec5230912aa2df82286dc1c379c9/testcases/sunset_logo/input.jxl?raw=true"
      sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
    end

    resource("sunset-logo-jxl").stage do
      system bin/"jxl-oxide", "input.jxl", "-o", testpath/"out.png"
    end
    assert_path_exists testpath/"out.png"
  end
end
