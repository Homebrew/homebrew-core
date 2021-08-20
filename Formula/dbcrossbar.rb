class Dbcrossbar < Formula
  desc "Copy tabular data between databases, CSV files and cloud storage"
  homepage "https://www.dbcrossbar.org/"
  url "https://github.com/dbcrossbar/dbcrossbar/archive/v0.5.0-beta.4.tar.gz"
  sha256 "0e694305811a771e8b5383efe9ff741c28b6f533a91b399d2326af60577e6c35"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dbcrossbar/dbcrossbar.git", branch: "main"

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "dbcrossbar")
  end

  test do
    (testpath/"table.sql").write <<~EOS
      CREATE TABLE my_table (
        id INT NOT NULL,
        name TEXT NOT NULL,
        quantity INT NOT NULL
      );
    EOS

    expected_json = <<~EOS.strip
      [
        {
          "name": "id",
          "type": "INT64",
          "mode": "REQUIRED"
        },
        {
          "name": "name",
          "type": "STRING",
          "mode": "REQUIRED"
        },
        {
          "name": "quantity",
          "type": "INT64",
          "mode": "REQUIRED"
        }
      ]
    EOS

    system bin/"dbcrossbar", "schema", "conv", "postgres-sql:table.sql", "bigquery-schema:table.json"
    assert_equal expected_json, File.read("table.json")
  end
end
