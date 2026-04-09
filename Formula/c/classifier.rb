class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "fc4ccdb302ead4758f8a2687c815250e050aa407145745150a92be474107d93f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19c7d40ed22261b05749e5a52ff43da0ef76227ae71ab08122df19ac8a92c6a3"
    sha256 cellar: :any,                 arm64_sequoia: "e1acfc4764c8ff12231bc6296e71b9da3053b67401d06077da86b51f840b2c7b"
    sha256 cellar: :any,                 arm64_sonoma:  "23f71b12e668e9fe3c13df7895ce0d78ddc3185c321d4cac8beff539d193c0c7"
    sha256 cellar: :any,                 sonoma:        "8a94fc5ddb9dd37f9b5fc70b9c235c6f0ebb6210665028008666abf1a316771c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3da13cbd9672dda25f43e2f21bc851c0ae68c6ba9ce2579b3856764bf46abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226f342aede197ee58be92f02d971e5f03df3e9759418713c6ac9193098fa0f1"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "classifier.gemspec"
    system "gem", "install", "classifier-#{version}.gem"

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
