class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.11.tar.gz"
  sha256 "1b55906c208b15354e4b7cff58a3c6d4df9097d23d8c8055ecd5bf39315e5a94"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9304a4973a57502a33e194993543d99799fab4a68a05676f8d452b6bc8cabe0"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d461b6baa8ed6a5b0e79e1d0cb525540604439b7f59497f97330b242b80aca2"
    sha256 cellar: :any_skip_relocation, catalina:      "4a23b96d4d0623c759e644add06bb0553963961a9396c37cb3f021db458c3db0"
    sha256 cellar: :any_skip_relocation, mojave:        "cb3131c069147d2870c9279cb662fc77452a662fe81bf504f9ff64bb67a50df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fff862799ef251dace6bdf78f97b5c0e6b16fcaff3c1291b6eb188a4e7d7568"
  end

  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
