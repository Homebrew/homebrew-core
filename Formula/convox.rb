class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.4.tar.gz"
  sha256 "62c288338824285110bc4e3565f9e342acef527d798ee632c3a2a175d5fd1e9b"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "babedecee1bcb56a57b1fec6db6dc39e225dbea06204460202b3a46febab2b91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "511992b9f21f701dbfff0c9248078b1bc546ce96d8704a81f69c6ff2eebfce14"
    sha256 cellar: :any_skip_relocation, monterey:       "699c7f0956cb01a5a3f05d18bd952a27e563f6ae49f5a7400575a75ac9332e46"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c1126a10f9c48778816aa875313b592310d99d415aaaa8607bcd6fe3d274e88"
    sha256 cellar: :any_skip_relocation, catalina:       "10f86998c40ea6ff9a163a649dc4340fbad77c4cd176473df1fe5d4c8a2fb058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4947b4ff1f3a315cf0b2333098426471c380e3c6adf5cb47d4473ea8796eed9b"
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
