class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "18",
      revision: "fba47f02d25be4350571e4daf7bb1373b37a5a90"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad23d3dc375b18d42f5770acd705bf1adf326ead97fc33c59bc153444f694258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0867c5e807d39e68956ea122e6fac4d718b038c47d0f39ff05619fd53b3095a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a010c8cbca6029bfa4f61a564bbfff611e0da4c2f67419f4122f85ae632b3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1373111890204196e4708c8c34246b3a5f81921a405245c31f99f213d1675dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c7f69520b21ce2c06436b7421166b5d1fec5abfc98bf0ca696952bf9877a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f97e1611e5ff8c3ccff3672e89db785d2d807ab7d7816e41935ba5ddbe28c0c"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output(bin/"neatvi", ":q\n")
  end
end
