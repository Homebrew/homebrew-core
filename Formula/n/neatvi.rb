class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "20",
      revision: "99f326adb10b40e53475beecec12e4a4eae92973"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf7a6647d589b4f4def74bed5e946696947913e02e599445836f2f8dc0299039"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc4ac7d0c83a2fe1cfafd9b346ddb557bad8ae2c65b329c5f147d34081f0b075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "524a5cac7a31d444d92130a946b7398e1730e7611d48947573cb6d370727deb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8930378e863751867482f026f641dbf2a0d95c93a8c4b02ced23ce4664be9f8d"
    sha256 cellar: :any_skip_relocation, sonoma:            "4cbf739bf7f2f2b447d20670fde95fcdf027f47aa3de0d26bfa7e6044dda5a95"
    sha256 cellar: :any,                 arm64_linux:       "90692aed7012e8022db467fd60480008f8fee6b6385a5f3e1caf3d9409213b14"
    sha256 cellar: :any,                 x86_64_linux:      "6f3e8f637d679d17af31784187ccb646e5094d62c410a1f81f9e44c90410e3b4"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output(bin/"neatvi", ":q\n")
  end
end
