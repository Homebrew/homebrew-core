class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.5.tar.gz"
  sha256 "ae4936ca71543da3a8880bd7edad9200dc99374560cce222d5c9a491c13dd119"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a70deb73144f8230c8419e5956efc63c7f6d37a3a8335b91edae15a288f08c0"
    sha256 cellar: :any,                 arm64_sequoia: "8f876968712d13cbd4f9d99a5b369eb4878f29bf04ba32eeb2b67c08bfd2a146"
    sha256 cellar: :any,                 arm64_sonoma:  "5669fa61483ea49b2ce40065c268a6789c8ae58f6d5b51ee82d05e426c613a25"
    sha256 cellar: :any,                 sonoma:        "4c04da909ff3a4bcae66bc39add9bf4ada194de1f69ac2d426673c7adcc868cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61191f5aef0fa9c2c012460d7f8ab06fd80d91095df08fd2f5202070d1a0958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2fa84c2b09c8b447c2ee868dccf242ac765e9b9a20a8ac6802bc720dcf7e76f"
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
