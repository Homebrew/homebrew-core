class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-5.2.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-5.2.0.tar.gz"
  sha256 "33659ba971c02fbedfbbd9214e06fb04e7b498b82653445c7fd28de0a9af6005"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b69212cbd2a3d9337a7f82a0a15542f260e5b95daf0938b113e869f859795d30"
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
