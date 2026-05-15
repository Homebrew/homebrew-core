class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-6.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-6.1.0.tar.gz"
  sha256 "653108a91fd9b309a89bc756258bae0bca01587cef475942d11852e3beba2ae3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b91af00edaad8af49ea8d7346c3777cff5797f0c92c6415d2dd02126bc0a0e92"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `update` binaries"
  conflicts_with "samba", because: "both install `tdbbackup` binaries"
  conflicts_with "tdb", because: "both install `tdbbackup`, `tdbdump` binaries"

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
