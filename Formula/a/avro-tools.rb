class AvroTools < Formula
  desc "Avro command-line tools and utilities"
  homepage "https://avro.apache.org/"
  # Upstreams tar.gz can't be opened by bsdtar on macOS
  # https://github.com/Homebrew/homebrew-core/pull/146296#issuecomment-1737945877
  # https://apple.stackexchange.com/questions/197839/why-is-extracting-this-tgz-throwing-an-error-on-my-mac-but-not-on-linux
  url "https://github.com/apache/avro.git",
      tag:      "release-1.11.3",
      revision: "35ff8b997738e4d983871902d47bfb67b3250734"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, ventura:        "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, monterey:       "057e636f05ecbb4b3bc843446726e58a763fc09fa96fa48b75811ca7824975bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bea5aa11cdf528f3c6de08510048a4f1d58e9a1055cb14b591ba7cc4512470c"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    cd "lang/java" do
      system "mvn", "clean", "--projects", "tools", "package", "-DskipTests"
      libexec.install "#{buildpath}/lang/java/tools/target/avro-tools-#{version}.jar"
      bin.write_jar_script libexec/"avro-tools-#{version}.jar", "avro-tools"
    end
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/avro-tools 2>&1", 1)
  end
end
