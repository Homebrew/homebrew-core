class CfnGuard < Formula
  desc "Check AWS CloudFormation templates for policy compliance"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/v0.5.2-beta.tar.gz"
  sha256 "05f48b30708c053367d5792b96af64914e149d7094a5b4c92f4d67d998e473b8"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    cd "cfn-guard" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # https://github.com/aws-cloudformation/cloudformation-guard/blob/master/Examples/ebs-volume-template.ruleset
    (testpath/"ebs.ruleset").write <<~EOS
      let encryption_flag = true
      let allowed_azs = [us-east-1a,us-east-1b,us-east-1c]

      AWS::EC2::Volume AvailabilityZone IN %allowed_azs
      AWS::EC2::Volume Encrypted == %encryption_flag
      AWS::EC2::Volume Size == 100
    EOS

    # https://github.com/aws-cloudformation/cloudformation-guard/blob/master/Examples/ebs-volume-template.json
    (testpath/"ebs.json").write <<~EOS
      {
        "Resources": {
          "NewVolume": {
            "Type": "AWS::EC2::Volume",
            "Properties": {
              "Size": 101,
              "Encrypted": false,
              "AvailabilityZone": "us-west-2b"
            }
          },
          "NewVolume2": {
            "Type": "AWS::EC2::Volume",
            "Properties": {
              "Size": 99,
              "Encrypted": false,
              "AvailabilityZone": "us-west-2c"
            }
          }
        }
      }
    EOS

    assert_match "Number of failures: 6",
      shell_output("#{bin}/cfn-guard -r #{testpath}/ebs.ruleset -t #{testpath}/ebs.json 2>&1", 2)
  end
end
