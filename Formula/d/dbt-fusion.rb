# typed: false
# frozen_string_literal: true

class DbtFusion < Formula
  desc "Rust-based command-line tool from dbt Labs that replaces dbt Core"
  homepage "https://github.com/dbt-labs/dbt-fusion"
  version "2.0.0-beta.21"

  depends_on "openssl@3"

  on_macos do
    on_arm do
      url "https://public.cdn.getdbt.com/fs/cli/fs-v2.0.0-beta.21-aarch64-apple-darwin.tar.gz"
      sha256 "ba97aadfd6dd2721bb7decd4088a99cf96283ecf5a01ee3a493e6aecb61b7ae4"
    end
    on_intel do
      url "https://public.cdn.getdbt.com/fs/cli/fs-v2.0.0-beta.21-x86_64-apple-darwin.tar.gz"
      sha256 "1c139e8d3c034f8a52858bd1241884d790434b79994b764731cccdf89774289a"
    end
  end

  def install
    bin.install "dbt" => "dbtf"
  end

  test do
    assert_predicate bin/"dbtf", :executable?
    assert_match "dbt-fusion", shell_output("#{bin}/dbtf --version")
  end
end
