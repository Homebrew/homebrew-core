class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.152",
      revision: "68477be3ff7171ee17ddd1a26064b9b253f1604f"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cfr[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b9f2ede10e95cb821c217666b2d683599416db1dfc2322f6f906e3206f35495d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4c353a0377fae2693e2c537b0e688bc99e883e0d918451061307cebf05789c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f63cb5e80ccaf8885580a6b7fddd4afa691bd875a8f6bee8ee059a385b7b4e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba4ca41c352f4dd210c5c399a898ab7f6ab79cc7487ff6f8339b8467d030a998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d83fad35c7406de903ee6b096ae977a648c1baeca9818c72dcc0a0fafe03b950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77864492e8a8dc89b6305770070c9f7fe4df482fff4c223d4f61e15f65636a68"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a450d930591e8c9da2fa0c5ea0f3bae35e5aacb44473713a5594998e0ecfa19"
    sha256 cellar: :any_skip_relocation, ventura:        "2974cd0863aa3f0b78ebe4d6a5be26e162e13ff464918996cb99ea144a41e0ba"
    sha256 cellar: :any_skip_relocation, monterey:       "129adb6ff234dcd57cf9c1de12827bd3ab7ccf551c0986a7f2e6e435c9d36d8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "20388572ac11cf3d8d0ad14ab428c8d5178e17e44eb32d20094fd3d384c72a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "03afb187594d2a088f3a6a111f7a34645860e0d51fb55afd82d6faa3404304ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b236e8effb84d1da66a9eec9c6b4d857d3471da8de57543ac7d029adb09b9eed"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # build
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system Formula["maven"].bin/"mvn", "package"

    cd "target" do
      # switch on jar names
      if build.head?
        lib_jar = Dir["cfr-*-SNAPSHOT.jar"]
        doc_jar = Dir["cfr-*-SNAPSHOT-javadoc.jar"]
        odie "Unexpected number of artifacts!" if (lib_jar.length != 1) || (doc_jar.length != 1)
        lib_jar = lib_jar[0]
        doc_jar = doc_jar[0]
      else
        lib_jar = "cfr-#{version}.jar"
        doc_jar = "cfr-#{version}-javadoc.jar"
      end

      # install library and binary
      libexec.install lib_jar
      bin.write_jar_script libexec/lib_jar, "cfr-decompiler", java_version: "11"

      # install library docs
      doc.install doc_jar
      mkdir doc/"javadoc"
      cd doc/"javadoc" do
        system Formula["openjdk@11"].bin/"jar", "-xf", doc/doc_jar
        rm_r("META-INF")
      end
    end
  end

  test do
    fixture = <<~JAVA
      /*
       * Decompiled with CFR #{version}.
       */
      class T {
          T() {
          }

          public static void main(String[] stringArray) {
              System.out.println("Hello brew!");
          }
      }
    JAVA
    (testpath/"T.java").write fixture
    system Formula["openjdk@11"].bin/"javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler --comments false T.class")
    assert_match fixture, output
  end
end
