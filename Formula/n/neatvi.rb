class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "14",
      revision: "e627fa1cea7e515832d219e9a3ad0cc50ee9e296"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2751444fd99b302401648aabd6070504d94bc5bdc25925fe4965274a2c756d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ef05eaa90ad1a183dd77557388b90c68bd757e1484aa3578ae0949ff6a263f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f647ead55d6d3231c38cb28b5b64d384d50240baba829397c9ab93987dfff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "66fef1879d28bb24389f3f851030ba4252dd4382414a103f21527b804ace6fe6"
    sha256 cellar: :any_skip_relocation, ventura:        "b49676a6acaa1928264e5d7bb071eb6259ea5c4cbacf561d328285ca033ec7d7"
    sha256 cellar: :any_skip_relocation, monterey:       "2fdea0baa48c43577ac3bb4bdf93121497370a108e837f1ce86b506aa8880e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26656649d196ab2e6898b915d275b1e2fda1fba388372b1c43ca911003aaaa5"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
