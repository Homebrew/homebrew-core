class Morphe < Formula
  desc "Desktop app and CLI for patching Android apps with Morphe"
  homepage "https://github.com/MorpheApp/morphe-desktop"
  url "https://github.com/MorpheApp/morphe-desktop/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d9c130df8d41d665233c660d11cdc6fea05fd7793b200ea89729fa7943656caf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e3e80ca5ba36272ab3152ed30133dfda8661ef1e660be4fc066168051634982"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e3e80ca5ba36272ab3152ed30133dfda8661ef1e660be4fc066168051634982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e3e80ca5ba36272ab3152ed30133dfda8661ef1e660be4fc066168051634982"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77f611efe20a71b190f4074a50d1abc1d0b8016fc08ab5ba41d0e117043e75c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "77f611efe20a71b190f4074a50d1abc1d0b8016fc08ab5ba41d0e117043e75c6"
  end

  depends_on "gradle" => :build
  depends_on "maven" => :build
  depends_on "openjdk"

  resource "morphe-patcher" do
    url "https://github.com/MorpheApp/morphe-patcher/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "5d97b3383409b95607861c197ee1aa2dbd6a59262812dab4628598724e0b18b5"

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

  # Unused by morphe-desktop itself but still required by `morphe-library`
  resource "jadb" do
    url "https://github.com/MorpheApp/jadb/archive/refs/tags/v1.2.3.tar.gz"
    sha256 "d2391d34c46d5844eee225e37e8b8b56ac5c4378073db1379cb9414b07b74da7"

    livecheck do
      url :url
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
