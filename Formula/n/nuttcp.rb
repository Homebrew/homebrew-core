class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "https://www.nuttcp.net/nuttcp/"
  url "https://www.nuttcp.net/nuttcp/nuttcp-8.2.2.tar.bz2"
  sha256 "7ead7a89e7aaa059d20e34042c58a198c2981cad729550d1388ddfc9036d3983"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?nuttcp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d600108d6b3d7e8b8b91dfa5a7a9b842e7c6b36553c6e6eea10b4c0172e1dc00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fa943ef3dca4e0414ccb634ed8246fa800eeb01f563c7578217bd4c9e156649d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3307110d7f6cb527152b3f3e70bdec5f80a89b5be55c27bada5b35d549d51714"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ac8108263034cac96c76efb07222a474c603fee130f0751dd9957bd52111280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "354b4a9b24a8af78f93bc7214b10137897a2bb04d49e42273a7b203265309fce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c284b20a30f158f7321ca918bc27ffac8f5e644e85acba6231477aa9c4a9f06e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cfa8c2cc2f19adca00c59e5f2a2ff0aadf5f5a3b35626c928437b83acdcc22a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f32f4184daaad9ca38c76c61eef16551706949199fc6ca890357547e249509c"
    sha256 cellar: :any_skip_relocation, monterey:       "23f6274a513fc5e03b2eba2ea26496beb8e1b7e21ac0824fb7abea9e3487b296"
    sha256 cellar: :any_skip_relocation, big_sur:        "9001ef97c90c4097f1ebabed20e63305f82a5f04d7ffc0f0d788c249c49d236d"
    sha256 cellar: :any_skip_relocation, catalina:       "0f5e7a2b61f91360023ef643c0a77fa711855b34006ff07867f1283051aded5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dcfba3237982e60f9c4605ff141b05308e4bad588891b72cf48df390df84fba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a45bf649ab4f28ef78699c00d3b71afa3655f26cafaeb01fb7f99fc9f133471"
  end

  def install
    system "make", "APP=nuttcp",
           "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "nuttcp"
    man8.install "nuttcp.cat" => "nuttcp.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuttcp -V")
  end
end
