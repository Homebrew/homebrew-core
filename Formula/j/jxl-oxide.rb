class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.11.0.tar.gz"
  sha256 "035ebefb13e7dce5cc9517ada36b5e677df0d5da7c613695ab82983f9be96f0f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e749b9f7c96dba73fb330ce26cff24f906b34e5cfe0fd10498ec63845fabf21e"
    sha256 cellar: :any,                 arm64_sonoma:  "f9774319e324e44e0f981aa7f036ae8e4b3513cc2165b73eeea878eb9c1ef9e8"
    sha256 cellar: :any,                 arm64_ventura: "6218e460376fc12cc3cccbbf554b23a66be0d6c959988e910d1ea383fd96aab0"
    sha256 cellar: :any,                 sonoma:        "d7bd67d051f8ae7bbb518b6366882509121f4567101cc1d24563ff9655da8ba1"
    sha256 cellar: :any,                 ventura:       "0e2dd6812957242a25ca607b957ac6dc522f1e08dc74f9b8370c1abca8d5c045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d591c14976cf450c922e1e2198c501c07229e2d415eadfa4700169297ceb0ca0"
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
    assert_predicate testpath/"out.png", :exist?
  end
end
