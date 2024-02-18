class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3740stable.tar.gz"
  version "3.74.0"
  sha256 "e6983379e3900328bfb1f572ae82fcb28f0d33df8fe8083018fea2dee098de41"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c363f649995d2e2b6642904e53d29014cb87de445a6bfacb6fff7d6af53006f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0f91dd30b36966b1479aa147fbd5f9798e6060f4573dafd715e511705cd2d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0a9379b58e0d29d4d000ba290e73ed50b869c84145cce7307b47f27ba0b1cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c1f436100c16e009acee8ebc9e6c3f1fbf9665803681253318296ff493c5bf6"
    sha256 cellar: :any_skip_relocation, ventura:        "201ada3481f9efa883b32133f8072b859d845d0cab47c3cad649b34472267237"
    sha256 cellar: :any_skip_relocation, monterey:       "d764bff2f7255e7b8dfb3cd23b9520086e02fd38b0d01d05e73da418352e535c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65ad63f3c33e6148f2ae606831239e3b1ad87d7fd83c2840112c1869d815a7d"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
