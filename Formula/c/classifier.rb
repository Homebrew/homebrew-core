class Classifier < Formula
  desc "Text classification with Bayes, LSI, kNN, Logistic Regression, and TF-IDF"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "3e0cf89c758eb4e7cb96a24dd39a422ec55c742d9663ee5fbb7fc63433deb872"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ba0432ac209fb148332377e1498b1e49bd711358e563011214302d9318405357"
    sha256 cellar: :any, arm64_sequoia: "872a0c9dd40f86f84a8de9c558f937ae482731ab2e0bdb95c0a26f35e32f7b28"
    sha256 cellar: :any, arm64_sonoma:  "cac7241f79adae3ec89c452270d31e2a1bda06dcb4d1b2af6bb7ccde040099cf"
    sha256 cellar: :any, sonoma:        "cdf1690ab9b7b7ed6fba8d98cd1d7b9d9607e8e42b346d99ff432806a7d73d45"
    sha256 cellar: :any, arm64_linux:   "47832ef61940bb4896389ade3d5615d744fe51c0f75b2f2534cc75f913be9e9a"
    sha256 cellar: :any, x86_64_linux:  "b293072ae4316ab3e797b5d1d622a1381af5475c61f8fc5d14a9c60ad38a13ae"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/classifier"
    bin.install libexec/"bin/keywords"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/classifier --version")

    # Test with pre-trained remote model (SMS spam detection)
    output = shell_output("#{bin}/classifier -r sms-spam-filter 'You won a free iPhone'")
    assert_match "spam", output.downcase

    output = shell_output("#{bin}/classifier -r sms-spam-filter 'Meeting at 3pm tomorrow'")
    assert_match "ham", output.downcase

    assert_match version.to_s, shell_output("#{bin}/keywords --version")

    # keywords ships no pre-trained model, so fit a vocabulary first
    (testpath/"corpus.txt").write <<~TEXT
      Ruby is an elegant programming language
      Python is a popular programming language
      Machine learning uses neural networks
    TEXT
    system bin/"keywords", "fit", "-m", testpath/"model.json", testpath/"corpus.txt"
    assert_path_exists testpath/"model.json"

    output = shell_output("#{bin}/keywords -m #{testpath}/model.json 'elegant ruby'")
    assert_match "elegant", output
  end
end
