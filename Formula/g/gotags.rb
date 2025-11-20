class Gotags < Formula
  desc "Tag generator for Go, compatible with ctags"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"
  license "MIT"
  head "https://github.com/jstemmer/gotags.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c1e572bc38c42b4bf4b0dc789976cd496403f2eca5526d89580a2b92d1187c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f52b68fbe9bb332e8897c64df4b8843de5290cfd2160f1b1854b6939c1475d8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa2004a6a7f413ec2536eccbce3ebd62a17b30f1fdd37085ff6f007fd39e756f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06c5aa68685eed2b5118a8dae5e6755fdb8a5498f134ea67640cf9b767b27433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea97844e0e99ab34a8e1efa76325fc7550a737d4bde6c0af1a36fe3b93ce7f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb7b2f4eda136713179e19853088af77dff04472ac4efc25fa0e48648398547"
    sha256 cellar: :any_skip_relocation, sonoma:         "41078758e9ceebf1c40863c4ee4d2acb0ec5fa1a215289f41ef2bd98dfe3dd27"
    sha256 cellar: :any_skip_relocation, ventura:        "ddb7aa582f4a228079c940fa4fb9a3cb003655e5ef73de506bb75aa23f49e070"
    sha256 cellar: :any_skip_relocation, monterey:       "703f8c955b818375693bbc165872b0253d9aedcff2c25cad5aeafc2d0e37448d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc346e7abc09f27730ca2face102e704855a4e105310b27d0dc25b465e8fb453"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b5430e2c3544fc021bc9bbc35c33a1f2c4482a30dbbc8d4977c1f0ee5638a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "054dd81acebaa03836623140d3083a451c17de08e5960da4db512f899255e04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab74768df76e27509e7b8b1739646d0cbbc721f4004e98f56711f837f9d9cb9"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write <<~GO
      package main

      type Foo struct {
          Bar int
      }
    GO

    assert_match(/^Bar.*test.go.*$/, shell_output("#{bin}/gotags #{testpath}/test.go"))
  end
end
