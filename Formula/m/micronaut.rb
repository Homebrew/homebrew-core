class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.9.4.tar.gz"
  sha256 "869abb30d22786d5d9b301c90986b98524f3525fc593dd5a243e154168838496"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42432c19454c1b12a8ec22642ab05d31606d6cbca09506723c724f6cb04c665f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5bed91d8f7d2bc12db86d3978a7676105549fd447bb8c152f7819b672709e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c0774b61d4d0f366dec9b53344fc74cb8be86200fc3f6257cf44580a40a8a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc44ba926fc4739ebdfdc2b0247638d626ed0f9af8b02d8a34150228853ab778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ca3089bc820fa9bbc66edf2cdaf17fed17d648f677cf7d1070ad06703a52a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14739f062e2657901ec909d02a82614530a46c3496079e5da8b529668bf20945"
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
