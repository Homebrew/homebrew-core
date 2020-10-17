class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.24/proteinortho-v6.0.24.tar.gz"
  sha256 "8c37ae3e99488b95a5e9f78df34bf0f049e127fc9abcbb76a2aab0e856d89acb"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "c60d377b05e0a58628b7eb1e7a850b5cd71bb5717f9ecaaaed31bdb97804b27b" => :catalina
    sha256 "753221939e85ce48bd5abb1abde59057ae25f3ffe2eb594019728f7074e98717" => :mojave
    sha256 "c7bfcb96b265b4604130f93df470051c72d757d1598e93f4152c07468220cf22" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
