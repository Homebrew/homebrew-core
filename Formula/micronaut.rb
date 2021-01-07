class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.3.tar.gz"
  sha256 "ebe3cfd4481b55cb6e0d77c0a0e9337b0a9ceea6b6089e2cd742f037675b6369"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ecd7bd9dae7d06113319aab1333c31bd54b225a3d69b9471471d630964ce2f24" => :big_sur
    sha256 "169cb09948e963a4db2709299f0ec178411242367dff7d213f6f2c882fce10a2" => :catalina
    sha256 "e4a358995e0cd3020812b7bd37ff2e1e21bc5c0bba66183b436deda20aff418a" => :mojave
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

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
