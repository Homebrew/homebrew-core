class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "6b754a7cb49e8cbc68b64ca7ed0130c2f6fe6436b4cf3d1acb8b62a5e83a56a3"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3b63cf7dfcfc82b4e7af46c87d02b4a5ff0fd1e6aaefdd9488c20be0bc65964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8555f19b0ece4d28bede4c65bc0dacf9d45c10506ecafaa58ee2ab8945665e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3843a160c6ed12a2e39664619aa947ed98a6de5b9630f0a3ce032423af9a806d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce5bca033caa3bc9a1a6302927f394f278065c0602d291fddf1c69828a329896"
    sha256 cellar: :any_skip_relocation, sonoma:        "669da278198ac01b56f2d21aec752e16ed89e0aff21ceb9ba8f0cf48eca3981e"
    sha256 cellar: :any_skip_relocation, ventura:       "775a53f96a8c848c2740de35f262c6da866329fe61dc074757280f75a80f68cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c112b3262e6423754bf1f68990aabc2f7ea07edcbb0cf01abe2e0262be4c3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d01ff344133fe4d95196c6133f1d7416a5325f1c7db27b3e621b8262b6afcd"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
