class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.20.0/overarch.jar"
  sha256 "ac9f3ad6024c74831f9ca5e7542ffcb54e8d028bba96508baa34a24b1068984e"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, ventura:        "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, monterey:       "2b79624443afc07d81fe2deb2febf9b6100a6f567e842dcec32c428a620c84b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de284ce0207a1873a2a7f44f6d3f1a59d44f73245eae313fb8e288ac6c5ecffd"
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
