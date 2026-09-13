class Linklint < Formula
  desc "Link checker and web site maintenance tool"
  homepage "http://linklint.org"
  url "http://linklint.org/download/linklint-2.3.5.tar.gz"
  sha256 "ecaee456a3c2d6a3bd18a580d6b09b6b7b825df3e59f900270fe3f84ec3ac9c7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef392eb8173eedd8caad7b9ac1d3aa0354fe9aeec2c6fe902b02bf1e9966518a"
  end

  deprecate! date: "2024-08-03", because: :repo_removed
  disable! date: "2025-08-03", because: :repo_removed

  def install
    mv "READ_ME.txt", "README"

    doc.install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    (testpath/"index.html").write('<a href="/">Home</a>')
    system bin/"linklint", "/"
  end
end
