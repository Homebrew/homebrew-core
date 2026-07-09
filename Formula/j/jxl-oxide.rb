class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.6.tar.gz"
  sha256 "d4ddd94b8d9c5d34424e3e228e07a5399aee9a388339fd6cd81b073eebf1e6de"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f7195891f2f2f8594c937b7288e609d76a87c4bb94e2744fce92c2a994cc2c1"
    sha256 cellar: :any, arm64_sequoia: "d94cd506af31d6cf33ea5e2f786ba1543d4c7fb791690551583b0a8f07fe6112"
    sha256 cellar: :any, arm64_sonoma:  "3b4bfb6401951facb9177d263eb362d397a8113ca4cb1182f6b7ddac965ae5f7"
    sha256 cellar: :any, sonoma:        "e3c1ba83fc751a56d2dd94557561f3244ef1de2c86b54f71bb7b6fad656cd265"
    sha256 cellar: :any, arm64_linux:   "6abe2f9b383c8eab6d397a721a158936fd4e16cc245cca7b60737667a2dd1f18"
    sha256 cellar: :any, x86_64_linux:  "f687d5a9d31d584ab250b708ccbbd7ca9406201c35414e8e8721995533737768"
  end

  depends_on "rust" => :build
  depends_on "little-cms2"

  def install
    ENV["LCMS2_LIB_DIR"] = formula_opt_lib("little-cms2").to_s
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
