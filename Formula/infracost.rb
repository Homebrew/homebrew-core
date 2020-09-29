class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.6.0.tar.gz"
  sha256 "0811501c923eeab88cc8a9bd0402344268402d0caa92398c8eab685b201bb8ce"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "228f812004b507dfdb0f1e3bae53801c0b89c10c6e3732a87d2b8b50ea1cb31c" => :catalina
    sha256 "c2d156a7993820f8dd95450389907957c916702673129643bcd856624b776eb3" => :mojave
    sha256 "6f2a3449c100879206e76aba5eda987c690e95a900b20145936f645bf207ccaf" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/infracost"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      provider "aws" {
        region                      = "us-east-1"
        s3_force_path_style         = true
        skip_credentials_validation = true
        skip_metadata_api_check     = true
        skip_requesting_account_id  = true
        access_key                  = "mock_access_key"
        secret_key                  = "mock_secret_key"
      }

      resource "aws_instance" "web_app" {
        ami           = "fake1"
        instance_type = "t3.micro"

        root_block_device {
          volume_size = 15
        }
      }
    EOS

    expected = <<~EOS
      [{
        "name": "aws_instance.web_app",
        "hourlyCost": "0.01245479452054795",
        "monthlyCost": "9.0920000000000035",
        "costComponents": [{
          "name": "Compute (on-demand, t3.micro)",
          "unit": "hours",
          "hourlyQuantity": "1",
          "monthlyQuantity": "730",
          "price": "0.0104",
          "hourlyCost": "0.0104",
          "monthlyCost": "7.592"
        }],
        "subresources": [{
          "name": "root_block_device",
          "hourlyCost": "0.00205479452054795",
          "monthlyCost": "1.5000000000000035",
          "costComponents": [{
            "name": "Storage",
            "unit": "GB-months",
            "hourlyQuantity": "0.0205479452054795",
            "monthlyQuantity": "15",
            "price": "0.1",
            "hourlyCost": "0.00205479452054795",
            "monthlyCost": "1.5"
          }]
        }]
      }]
    EOS

    output = shell_output("#{bin}/infracost --no-color --tfdir . --output json")
    assert_equal JSON.parse(expected), JSON.parse(output)
  end
end
