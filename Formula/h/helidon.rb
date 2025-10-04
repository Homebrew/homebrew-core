class Helidon < Formula
  desc "Command-line tool for Helidon application development"
  homepage "https://helidon.io/"
  url "https://github.com/helidon-io/helidon-build-tools/archive/refs/tags/3.0.6.tar.gz"
  sha256 "749cf3fd162bb9449ab57584c0bdf8874114d678499071ea522c047637de0f90"
  license "Apache-2.0"
  revision 1

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cc786871d00edd3eb256fb4c537dff764982508420932d996786c0f17c6d417b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7c9501af89a38771d60a2615d6b5f14e689a193f4b6661493e2710c6ee916ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4248959a9bfb64c7228ddd2e2e34863e59f513617cbe45f7de7c2c50cdd9ef2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3517a8e1438fea1afb60a5d51da906a0e9c92d3cebce10f88298818974e3caf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0aa3e9cddf0f4892cadd4d96b6d48a887ac2a9f43a8e8693fc38c5a843bb8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "27cce977bf0cb83027055f100992353b129041bfe38e50c796a7f485bb579311"
    sha256 cellar: :any_skip_relocation, ventura:        "67f45ccc046d27bcbc02ce5c817156aa3762e8bebf19becefc49e2afd56e2311"
    sha256 cellar: :any_skip_relocation, monterey:       "3f2434d267c5098e823d76ea786c6568f76f2519952166d203a2e283268d1fb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "41d184bf37f0efdace3ffe845a427439daf9a1993422d88d4a5bfcbf31edce67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155ba1f8e4903a933f1e28b19bce7efa6cbf2a0514e1391627410aad8ffe8d18"
  end

  depends_on "maven"
  depends_on "openjdk"

  def install
    system "mvn", "package", "-f", "cli/impl/pom.xml", "-DskipTests"
    system "unzip", "cli/impl/target/helidon-cli"
    libexec.install "helidon-#{version}/bin", "helidon-#{version}/helidon-cli.jar", "helidon-#{version}/libs"
    (bin/"helidon").write_env_script libexec/"bin/helidon", Language::Java.overridable_java_home_env
  end

  test do
    # Avoid error: java.lang.IllegalArgumentException: `HOMEBREW_CACHE/"java_cache"` does not exist
    mkdir_p HOMEBREW_CACHE/"java_cache"

    system bin/"helidon", "init", "--batch"
    assert_predicate testpath/"quickstart-se", :directory?
  end
end
