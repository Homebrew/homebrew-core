class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.15.1/overarch.jar"
  sha256 "62cd8cc81ac542982afb3481345a3527a609685608efed1c909bcfac9a3493cd"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbbb57004dd936ff238c56db71ef8a7d1128fcf724233356050e3e60ead5cc40"
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
