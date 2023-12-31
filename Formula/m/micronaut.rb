class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "b458b41d48c23ac19b3b3c62aa38860c9ce8a3d522d275dd4a229524cc220c70"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46e4819d3c8d4e0ee65449912ae44a3c02a5440a3a56baf7cd3c0c19e377fde5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "953fecccef7785ad3e79cb39bd3202f4b351fd8574cc7a55c3dd250e962b98f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5be8040332a0074e9dad5cf0f0a47d69c4f33e082b874a50035cf1d7dc495b"
    sha256 cellar: :any_skip_relocation, sonoma:         "93eac2ec69db7ecb2baef64b4b7271e0d3d22b0d69a0a55f7a3f4600f76e5e14"
    sha256 cellar: :any_skip_relocation, ventura:        "efb57b30bfe3851fa3ab8322968e88aa3518572954d004bbcc9e8402f8c12811"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1f1ecb2bb4acaee3ba0df796e65b6bd5da9a80dc54cea9fb7446524bf87b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5d53b0bf5b3a7473a71cbf491c79564121fb293b41a4adbe563d430affe6203"
  end

  depends_on "gradle" => :build
  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
