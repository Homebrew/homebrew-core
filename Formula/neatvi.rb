class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "11",
      revision: "c4d323dc210ae5dcd828b0222b3748c3e1de2abc"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e7fdbac653c245add71a34e2e6b0b9233a7bcef81950f4bf623ff1f35f97a2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883714f144e2c79eda69d2b71fae84815e02c628f9c86367d4f5ff43ccb39b68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d4d7ff1f32113f9f33451d6eeccf6d3be561db29330c7c9a25000b7e555bb28"
    sha256 cellar: :any_skip_relocation, ventura:        "b90a75d82578f361df69fd0a25be7a522c1096ada34428d39da2af1a616a103a"
    sha256 cellar: :any_skip_relocation, monterey:       "1c34a015946a3eded43b703df0ca43561d22c2d73f0d1fed6de80363cd88f740"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d4bf914826b2faa593d07493d7fa4e0179119a7aa80f821627b3f397111f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ff9d1f12cefb418f24e61797c076c954a3596694ee4bf7868cc57743cf90be"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
