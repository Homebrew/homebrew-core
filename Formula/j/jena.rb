class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.1.0.tar.gz"
  sha256 "2ec367a3fb362852b293128dee49532df9855aefe3b5724257d4c53d7fceb21e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, ventura:        "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, monterey:       "13242c46df5bef7fde15f051ae719b70763fc44d39e49c43a9ce2257c0ee73a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6ede1a41b42bc10b71462009a35bda25cfb9808d1636be2cf6e7676259f781"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `update` binaries"
  conflicts_with "samba", because: "both install `tdbbackup` binaries"

  def install
    env = {
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      JENA_HOME: libexec,
    }

    rm_r("bat") # Remove Windows scripts

    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  test do
    system bin/"sparql", "--version"
  end
end
