class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "fc4ccdb302ead4758f8a2687c815250e050aa407145745150a92be474107d93f"
  license "LGPL-2.1-or-later"

  depends_on "ruby@3.4"

  resource "fast-stemmer" do
    url "https://rubygems.org/gems/fast-stemmer-1.0.2.gem"
    sha256 "d0aa9fd9cfbca836a09d8abb122552ac8234130271a3b0da1cb077323d650819"
  end

  resource "mutex_m" do
    url "https://rubygems.org/gems/mutex_m-0.3.0.gem"
    sha256 "cfcb04ac16b69c4813777022fdceda24e9f798e48092a2b817eb4c0a782b0751"
  end

  resource "matrix" do
    url "https://rubygems.org/gems/matrix-0.4.3.gem"
    sha256 "a0d5ab7ddcc1973ff690ab361b67f359acbb16958d1dc072b8b956a286564c5b"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-13.2.1.gem"
    sha256 "46cb38dae65d7d74b6020a4ac9d48afed8eb8149c040eccf0523bec91907059d"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "classifier.gemspec"
    system "gem", "install", "--ignore-dependencies", "classifier-#{version}.gem",
           "--install-dir", libexec

    bin.install libexec/"bin/classifier"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/classifier --version")

    # Test with pre-trained remote model (SMS spam detection)
    output = shell_output("#{bin}/classifier -r sms-spam-filter 'You won a free iPhone'")
    assert_match "spam", output.downcase

    output = shell_output("#{bin}/classifier -r sms-spam-filter 'Meeting at 3pm tomorrow'")
    assert_match "ham", output.downcase
  end
end
