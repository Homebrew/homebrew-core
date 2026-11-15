class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-6.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-6.2.0.tar.gz"
  sha256 "14c12ef4aa2f0078a473be4b10b015e0e0b85e767d6867e8581679de8fec3f6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7467ee5fd13c634c65af9e517b7441c93200c0f3ef31a723e12181b65f205503"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `update` binaries"
  conflicts_with "samba", because: "both install `tdbbackup` binaries"
  conflicts_with "tdb", because: "both install `tdbbackup`, `tdbdump` binaries"

  def install
    env = {
      JAVA_HOME: formula_opt_prefix("openjdk"),
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
