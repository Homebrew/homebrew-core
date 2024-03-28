class PklGenSwift < Formula
  desc "Pkl bindings for the Swift programming language"
  homepage "https://pkl-lang.org/swift/current/index.html"
  url "https://github.com/apple/pkl-swift/archive/refs/tags/0.2.3.tar.gz"
  sha256 "2318ab9f641237a70531652b78fcdcf2e9cb609f96e5386778dd08e14fe847b4"
  license "Apache-2.0"

  depends_on "pkl"
  depends_on xcode: ["15.2"]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--product", "pkl-gen-swift", "--configuration", "release"
    bin.install ".build/release/pkl-gen-swift"
  end

  test do
    (testpath/"intro.pkl").write <<~EOS
      name = "Pkl: Configure your Systems in New Ways"
    EOS

    system "#{bin}/pkl-gen-swift", "#{testpath}/intro.pkl", "-o", "#{testpath}/out/"
    assert_predicate testpath/"out/intro.pkl.swift", :exist?

    assert_match version.to_s, shell_output("#{bin}/pkl-gen-swift --version")
  end
end
