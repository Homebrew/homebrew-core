class Morphe < Formula
  desc "Desktop app and CLI for patching Android apps with Morphe"
  homepage "https://github.com/MorpheApp/morphe-desktop"
  url "https://github.com/MorpheApp/morphe-desktop/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "31df678274df385132acd241eae844eb2489bf0041d860f2b50a06fa4db60e47"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "744ef756d7a2044b5018b1d60b5ff83600199ff6f92d467cf6aa77941b4cc198"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "744ef756d7a2044b5018b1d60b5ff83600199ff6f92d467cf6aa77941b4cc198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "744ef756d7a2044b5018b1d60b5ff83600199ff6f92d467cf6aa77941b4cc198"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14c06eca9d42005c76789f86db2023009ddf3bcc8e0fb40a29b896dc34a53fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "14c06eca9d42005c76789f86db2023009ddf3bcc8e0fb40a29b896dc34a53fd0"
  end

  depends_on "gradle" => :build
  depends_on "maven" => :build
  depends_on "openjdk"

  resource "morphe-patcher" do
    url "https://github.com/MorpheApp/morphe-patcher/archive/refs/tags/v1.15.1.tar.gz"
    sha256 "f7accdd98a7b8fb954294f5920bcfce6154b6317af4c824f0677f34274436e91"

    livecheck do
      url "https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^morphe-patcher\s*=\s*"([^"]+)"/)
    end
  end

  resource "morphe-library" do
    url "https://github.com/MorpheApp/morphe-library/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "b6c78c45e90b44bca6c3aa12f7ea9281396eac4dbdecaee23ee30b312f4e2b50"

    livecheck do
      url "https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^morphe-library\s*=\s*"([^"]+)"/)
    end
  end

  resource "jadb" do
    url "https://github.com/MorpheApp/jadb/archive/refs/tags/v1.2.3.tar.gz"
    sha256 "d2391d34c46d5844eee225e37e8b8b56ac5c4378073db1379cb9414b07b74da7"

    livecheck do
      url "https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^jadb\s*=\s*"([^"]+)"/)
    end
  end

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Build these from source as their published packages require GitHub authentication
    %w[morphe-patcher morphe-library].each { |r| resource(r).stage buildpath/r }
    inreplace "settings.gradle.kts" do |s|
      s.gsub! 'file("../$libraryPath")', 'file("$libraryPath")'
      s.gsub! "app.morphe:morphe-library", "app.morphe:morphe-library-jvm"
    end
    resource("jadb").stage { system "mvn", "--batch-mode", "-Dmaven.test.skip=true", "install" }

    # Use Homebrew's JDK instead of downloading JetBrains Runtime; there are no Java sources to target
    inreplace "build.gradle.kts", /^ *jvmToolchain \{\n.*?^ *\}\n/m, ""

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
