class Flutter < Formula
  desc "Google’s UI toolkit for mobile, web, and desktop from a single codebase"
  homepage "https://flutter.dev"
  url "https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.9.1+hotfix.6-stable.zip"
  sha256 "8d0b3e217e45fbde64e117c5932ec5bd18ced0e8e8fba80a0fec95e38854bb6a"

  def install
    cp_r ".", prefix
  end

  def post_install
    chmod_R "u+w", prefix/"bin/cache"
  end

  test do
    system "#{bin}/flutter", "create brew_test"
    assert_predicate testpath/"brew_test/brew_test.iml", :exist?
  end
end
