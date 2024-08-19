class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.29.1/overarch.jar"
  sha256 "d7fbed38312180dd5f17ca6d8089458268095619b678fba4a1c1e52660d61d1f"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, sonoma:         "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, ventura:        "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, monterey:       "3363eaa87a1637f544491951b53eb634c232ee574689b9941e3e50fc13256e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d52e9bc90c8fc0fff13c93041dd3ba4760b92c7292aff8db934e2a7c595c838"
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
      {:nodes-by-type-count {:person 1, :system 1},
       :nodes-count 2,
       :views-by-type-count {:container-view 1, :context-view 1},
       :relations-by-type-count {:rel 1},
       :views-count 2,
       :elements-by-namespace-count {nil 3},
       :relations-count 1,
       :synthetic-count {:normal 3},
       :external-count {:internal 3}}
    EOS
    assert_equal expected, shell_output("#{bin}/overarch --model-dir=#{testpath} --model-info").chomp
  end
end
