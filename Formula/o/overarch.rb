class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.21.0/overarch.jar"
  sha256 "37dc64fd655dfe5e8e8a40f0f6f3e2c9b9a9fef68ff0e817ef997ec5d7423e39"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, ventura:        "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, monterey:       "54b28a532c1bdff5258f9d7d6be024da7d0ad082027b53848eb1dd466ea705bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b895299f4c0654cd3e38a08aeb7aaccc3f0581d36b2957aad0ae42d9bb4d55e"
  end

  head do
    url "https://github.com/soulspace-org/overarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "target/overarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec/"overarch.jar", "overarch"
  end

  test do
    (testpath/"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}/overarch --model-dir=#{testpath} --model-info").chomp
  end
end
