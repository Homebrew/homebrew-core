class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/janeczku/docker-machine-vultr"
  url "https://github.com/janeczku/docker-machine-vultr/archive/v1.4.0.tar.gz"
  sha256 "f69b1b33c7c73bea4ab1980fbf59b7ba546221d31229d03749edee24a1e7e8b5"
  license "MIT"
  head "https://github.com/janeczku/docker-machine-vultr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eac2e453fb12dfc95df44c84afa1e502f92e7d0b49922ec2028ddcddf3ad036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e99d94cf096740acbfb7569e571bedcfcea8fb17fa084cd60395c6b668c74aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53bbef8c94f0a9dbe4aabb21ad4573b66e3aac1991730cbc4c4624650918b7a6"
    sha256 cellar: :any_skip_relocation, ventura:        "10213a1e41b628cd9dfc36c5e936da5baa77f2db328fb4a4f459960a2a264929"
    sha256 cellar: :any_skip_relocation, monterey:       "fa38432759e28dfa52ee3e482109b7c20ca70221596e87c4282a8b929a5c9210"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97e13c520424fdb1f5f445fa9defde64a487654dab45cae55925edb5ae49aa0"
    sha256 cellar: :any_skip_relocation, catalina:       "5bf083ff423d2ca45f4593c6abeecd57f097f51d17fea884eb0a245060b410a1"
    sha256 cellar: :any_skip_relocation, mojave:         "8c6a8d5fa979b04816723a10af5f4150228a6e20425defb443061e375020a948"
    sha256 cellar: :any_skip_relocation, high_sierra:    "62f227cf1a4c854fc311024d892a40e71a061576a051818126a469f2213400ca"
    sha256 cellar: :any_skip_relocation, sierra:         "7af4e94255b4b0ffe451c7f73355adee8ca6fcc4e8a38ba7157acee1a3ba1409"
    sha256 cellar: :any_skip_relocation, el_capitan:     "50ae18bed6b26893049da20e16dbbcaaabbde2078df7fd6c9be6ce2e42f4f77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60610ec215e212a442adf660b34f651db0c97a75cfe7ca908e00c8d450ccd8f4"
  end

  # last commit was in 2017
  deprecate! date: "2022-07-29", because: :unmaintained

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/janeczku/docker-machine-vultr").install buildpath.children

    cd "src/github.com/janeczku/docker-machine-vultr" do
      system "make"
      bin.install "build/docker-machine-driver-vultr-v#{version}" => "docker-machine-driver-vultr"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "--vultr-api-endpoint",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
