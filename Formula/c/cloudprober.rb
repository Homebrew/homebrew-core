class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "e5ee8db5b0f571ab08eb3879d31b5fe301c1f17d49245962974544f823b63576"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b256f494cfb86241fb43e692330fc1464106d631f9b8dbd4577dd0ea0e972284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be2ae4477185c3a005f4bc08c4e73c294fcb39f8176ca86cff1aa23d6ef3c2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a63d8862c8d0c153c4e0ea6434d94c3f56f4dde81b239466ccb90fb1066b09f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5eb24a3fdde82d73fb237713ab724db25b31c44f906b58ade89d7591c96fa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18164a537158db17d3bb58c71bdaea31d326175fba7ae253d46c4696273a430"
    sha256 cellar: :any_skip_relocation, ventura:        "09ba04d2b4ae6575edeaafaeb3bd727b51fd4caa9f54a5742a594f10496ef0ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9cc86a7122059b488f0e42d9e18aa1e1dbcdf1fdeaeec159a5b6825483ca43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e81dc62e9ec39bd2745237dd191d486e8454160a6f3938b71ebd9c45163d6b3"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
