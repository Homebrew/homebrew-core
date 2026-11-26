class Morphe < Formula
  desc "Desktop app and CLI for patching Android apps with Morphe"
  homepage "https://github.com/MorpheApp/morphe-desktop"
  url "https://github.com/MorpheApp/morphe-desktop/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "901cc9200ac5e727629499803b0c70fcf5589769377b3e5de8269276a9524bf0"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "0a9bee99226fdeb7af61a21399c7dcb9a80c90a9af60759c8ac85d3250de7430"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d08e5b84224d3507451e72101a4b80e0b004d2db2c1109580acf2e4944a80183"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d08e5b84224d3507451e72101a4b80e0b004d2db2c1109580acf2e4944a80183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d08e5b84224d3507451e72101a4b80e0b004d2db2c1109580acf2e4944a80183"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c5c8ade2beca08d3a3c325cb35f00f2eb6a17f9f030dfea30a6c66dd334760a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c5c8ade2beca08d3a3c325cb35f00f2eb6a17f9f030dfea30a6c66dd334760a1"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  resource "morphe-patcher" do
    url "https://github.com/MorpheApp/morphe-patcher/archive/refs/tags/v2.6.0.tar.gz"
    sha256 "b1b795049b70a2140d3a0fd9e9a1e9afb00e5c44de15bac1c84866e9104781f5"

    livecheck do
      url "https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^morphe-patcher\s*=\s*"([^"]+)"/)
    end
  end

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Build the patcher from source because its published package requires GitHub authentication.
    resource("morphe-patcher").stage buildpath/"morphe-patcher"
    inreplace "settings.gradle.kts", 'file("../$libraryPath")', 'file("$libraryPath")'

    # Keep public dependencies on public repositories; Morphe components are built locally above.
    inreplace "build.gradle.kts", "credentials {", 'content { includeGroup("app.morphe") }; credentials {'

    # Use Homebrew's JDK instead of downloading a separate toolchain.
    inreplace "build.gradle.kts", "jvmToolchain(21)", ""

    system "gradle", "--no-daemon", "-Pkotlin.jvm.target.validation.mode=ignore", "shadowJar"

    libexec.install "build/libs/morphe-desktop-#{version}-all.jar" => "morphe.jar"
    (bin/"morphe").write <<~SH
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
      export MORPHE_DATA_DIR="${MORPHE_DATA_DIR:-#{var}/morphe}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/morphe.jar" "$@"
    SH
  end

  test do
    data_dir = testpath/"morphe-data"
    (data_dir/"patches").mkpath
    (data_dir/"patches/stale.mpp").write "cached patch"
    output = shell_output("MORPHE_DATA_DIR=#{data_dir} #{bin}/morphe utility clear-cache 2>&1")
    assert_match "Cache cleared", output
    refute_path_exists data_dir/"patches/stale.mpp"
  end
end
