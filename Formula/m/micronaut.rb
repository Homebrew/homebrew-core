class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "192c78833d2a9cef278cb7a4b8ea699bb4b6ec4f20e9805e017d2737341cad80"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99199f73b300e745ab5ea2c651edd445742db8c5ea55260747496953f74ae3d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa10567ebb149a1645fcbf4d0f44e17e6bac57470981e0d4fe4f2fd728967c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c938da510afc55b013d15a45b684a0ad133487ef9ae17c67cdcad2a51e9bfd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c2b2102ec2f47944b8e607771e77152dbc88748ea1f08ad5e0d079a274276ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a757f04f09b9dc1af28e26ea75c3a7353ee49bcea2b075de8e80e59d38942dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4b349bad6c541abe52239a0218b829d40e1a4c4ee8dab795c2f273ecbba967"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
