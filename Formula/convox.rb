class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.5.tar.gz"
  sha256 "bf3dcaeff130e1da9e44ff2a9d96dbcdb14dcead38b276ac8be5b7e1803d7c40"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95015f186e6d07ffaeffffc87b9ac502b3aedfe2ef36dcdc0f45da4c96f57291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eb3b0a49433d877344a49c7aaae74a6c638775c7dc6ff6263430fa5fa157e5b"
    sha256 cellar: :any_skip_relocation, monterey:       "f732017e950e83dd542dbda6f112b30d493eb7d8a7d8f11c615f5a1f47670d79"
    sha256 cellar: :any_skip_relocation, big_sur:        "36038aac690e8f1ecf2723ff5d6d0fd2a4ee7222d2a91d3ae065e436d8bded1c"
    sha256 cellar: :any_skip_relocation, catalina:       "4d5b2b1f1f6548d2e12fe7b302c700d878050401f3dced10c5a25525ddc0b93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f3c6fe33201db850bb59275cfd15a5508f5e38b490dd703c0e7131d1106f34"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
