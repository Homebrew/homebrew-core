class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.2.tar.gz"
  sha256 "0d2b812051b64ab443c444035e7ccf4a53e8d823608c1c6b9997c3e6c43f729c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ef5a846c6ce8e8e8819712bb097782e9670bdfd293aba5973524abf76b2c4e2"
    sha256 cellar: :any,                 arm64_sonoma:  "cb4acba8480cab4a2a20b4347d687d6eb8980ce2ed69d50cc8f19adde2347327"
    sha256 cellar: :any,                 arm64_ventura: "01886bc00349b81cc6c11d6e2ee8f3b0a1b1bdea0c023368d8c3bf88ab1cbdd0"
    sha256 cellar: :any,                 sonoma:        "57ed9baf6520a635a01710a29b5e21bcd26a7fab8c62595deef5faa1c4c8e836"
    sha256 cellar: :any,                 ventura:       "7320c637ed90444b0b060a962efcf0801f127cc859717f4d9d97b0a08bcfc8ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39164022d29a53a18003247a47cd45ff1d53d01cf1b8c15851a8fb655ca5efaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d8cd9590f564c7766f13eb9e348be38cad7ad26cacb9f0fb8d56845008c429"
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
