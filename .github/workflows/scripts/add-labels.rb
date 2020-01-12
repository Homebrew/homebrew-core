require "octokit"

client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

repo = ENV["GITHUB_REPOSITORY"]
pr_number = ENV["GITHUB_REF"].split("/")[2]

pr_files = client.pull_request_files(repo, pr_number)

pr_labels = {
  no_bottles: 0
}

pr_files.each do |file|
  formula = file[:filename]

  if File.exist?(formula) && File.read(formula).match(/bottle :unneeded/)
    pr_labels[:no_bottles] += 1
  end
end

if pr_files.count == pr_labels[:no_bottles]
  puts "Adding the 'no-bottles' label."
  client.add_labels_to_an_issue(repo, pr_number, ["no-bottles"])
else
  puts "Not labelling this PR as there's a mixture of bottled and unbottled formulae."
end
