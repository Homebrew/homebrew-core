class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https://github.com/soulspace-org/overarch"
  url "https://github.com/soulspace-org/overarch/releases/download/v0.40.0/overarch.jar"
  sha256 "368b865b4909143f3bf3da711709a4d1d39c04fac9b8585e90c35df540b4fb18"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "019d9f6fdec57aa21267fa20a873af588bb5ada1c60751ff4943f4aa090a1393"
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
      {:build-problems (),
       :unresolved-refs-in-views (),
       :unresolved-refs-in-relations ()}
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
