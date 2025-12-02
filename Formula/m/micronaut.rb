class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.10.2.tar.gz"
  sha256 "0927f7648316eef61c8eb67531a079a0b8fdb3a5ae6be0f9a22f0728cc624887"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1126904f79b45833dfbdf219038a330c14a1d040cdfad98ee815960b003f7e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41440119d283f976723106b8dba4e9e6913fd1e91a4026a9912da3850b2f4990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb24a7ff9e920026ef0c04a9d0a0a52bf16408eb21583fa335267f49371112c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "861649d21e56f79111c0cb2d8726c917a2d109d1a5164a12ab6fe90ec4b39327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462a126df4a08903e372fe68501e5f9f8a92686942864ec3d448974884c4c949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae04d4490867a6826893ddb3dacf1b3dbcd0c0865ef78cacba631d4ffc685beb"
  end

  # Issue ref: https://github.com/micronaut-projects/micronaut-starter/issues/2848
  depends_on "gradle@8" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("21")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
